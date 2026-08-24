#!/bin/bash

# Exit immediately if any command fails, even inside a pipe stream
set -e
set -o pipefail

# --- CONFIGURATION ---
BASE_DIR="/home/ibab/BDBP307/20260821_RNA_seq/all_rna_seq"
REF_FASTA="${BASE_DIR}/ref/PlasmoDB-71_Pfalciparum3D7_Genome.fasta"
REF_INDEX_PREFIX="${BASE_DIR}/ref/pf3d7_index" # Basename for HISAT2 index
THREADS=8 

# Define output directories
RAW_DIR="${BASE_DIR}/raw_all"
RAW_FQC_DIR="${BASE_DIR}/fastqc_raw"
TRIM_DIR="${BASE_DIR}/trim_all"
ALIGN_DIR="${BASE_DIR}/aligned_all"
QUALIMAP_DIR="${BASE_DIR}/qualimap"
MQC_DIR="${BASE_DIR}/multiqc_all"

# Create directories if they don't exist
mkdir -p "$RAW_FQC_DIR" "$TRIM_DIR" "$ALIGN_DIR" "$QUALIMAP_DIR" "$MQC_DIR"

# --- STEP 0: BUILD INDEX (If it doesn't already exist) ---
if [ ! -f "${REF_INDEX_PREFIX}.1.ht2" ]; then
    echo "========================================================="
    echo " BUILDING HISAT2 GENOME INDEX"
    echo "========================================================="
    hisat2-build -p "$THREADS" "$REF_FASTA" "$REF_INDEX_PREFIX"
else
    echo "Genome index already exists. Skipping build step."
fi

# --- SAMPLE LIST ---
SAMPLES=("SRR15276765" "SRR15276766" "SRR15276767" "SRR15276773" "SRR15276774")

# --- PIPELINE LOOP ---
for SAMPLE in "${SAMPLES[@]}"; do
    echo "========================================================="
    echo " PROCESSING SAMPLE: ${SAMPLE}"
    echo "========================================================="
    
    RAW_R1="${RAW_DIR}/${SAMPLE}_1.fastq.gz"
    RAW_R2="${RAW_DIR}/${SAMPLE}_2.fastq.gz"
    
    # Step 1: FastQC on Raw Data
    echo "[1/6] Running FastQC on Raw Data..."
    fastqc -t "$THREADS" -o "$RAW_FQC_DIR" "$RAW_R1" "$RAW_R2"

    # Step 2: Quality Trimming & Post-Trim FastQC
    echo "[2/6] Running Trim Galore! (+ Post-Trim FastQC)..."
    trim_galore --paired --fastqc --output_dir "$TRIM_DIR" "$RAW_R1" "$RAW_R2"

    # Define expected paths to the trimmed outputs
    R1="${TRIM_DIR}/${SAMPLE}_1_val_1.fq.gz"
    R2="${TRIM_DIR}/${SAMPLE}_2_val_2.fq.gz"

    # Step 3: Alignment (HISAT2) using the built index prefix
    echo "[3/6] Running HISAT2 Alignment..."
    hisat2 -p "$THREADS" -x "$REF_INDEX_PREFIX" -1 "$R1" -2 "$R2" 2> "${ALIGN_DIR}/${SAMPLE}_hisat2.log" | samtools view -b - > "${ALIGN_DIR}/${SAMPLE}.unsorted.bam"

    # Step 4: Coordinate Sorting (Samtools sort)
    echo "[4/6] Sorting BAM by coordinate..."
    samtools sort -@ "$THREADS" "${ALIGN_DIR}/${SAMPLE}.unsorted.bam" -o "${ALIGN_DIR}/${SAMPLE}.sorted.bam"

    # Step 5: Indexing (Samtools index)
    echo "[5/6] Indexing sorted BAM..."
    samtools index "${ALIGN_DIR}/${SAMPLE}.sorted.bam"

    # Step 6: Qualimap BAM QC
    echo "[6/6] Running Qualimap BAM QC..."
    qualimap bamqc -bam "${ALIGN_DIR}/${SAMPLE}.sorted.bam" -outdir "${QUALIMAP_DIR}/${SAMPLE}_qualimap" --java-mem-size=4G -nt "$THREADS"

    # Clean up massive temporary unsorted BAM files to save space
    rm "${ALIGN_DIR}/${SAMPLE}.unsorted.bam"

    echo "Finished processing ${SAMPLE} successfully!"
    echo ""
done

# --- FINAL AGGREGATION ---
echo "========================================================="
echo " RUNNING MULTIQC"
echo "========================================================="
multiqc "$BASE_DIR" -o "$MQC_DIR" -n Pfalciparum_Project_Report

echo "Pipeline script finished running smoothly!"
