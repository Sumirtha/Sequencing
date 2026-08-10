July 24 2026 Genome assembly

#spades 
mkdir 202607024_spades
spades.py -1 SRR8389900_1_val_1.fq -2 SRR8389900_2_val_2.fq -t 20 -m 10 --cov-cutoff auto -o /home/ibab/BDBP307/20260723_1_bacterial_genome_assembly/trim/trim_20/202607024_spades

#manual count
grep '>' /home/ibab/BDBP307/20260723_1_bacterial_genome_assembly/assembly/202607024_spades/K77/scaffolds.fasta | wc -l
grep '>' scaffolds.fasta | wc -l/home/ibab/BDBP307/20260723_1_bacterial_genome_assembly/assembly/202607024_spades/K21/scaffolds.fasta
grep '>' /home/ibab/BDBP307/20260723_1_bacterial_genome_assembly/assembly/202607024_spades/K21/scaffolds.fasta | wc -l
grep '>' /home/ibab/BDBP307/20260723_1_bacterial_genome_assembly/assembly/202607024_spades/K55/scaffolds.fasta | wc -l
grep '>' /home/ibab/BDBP307/20260723_1_bacterial_genome_assembly/assembly/202607024_spades/K33/scaffolds.fasta | wc -l
grep '>' /home/ibab/BDBP307/20260723_1_bacterial_genome_assembly/assembly/202607024_spades/K33/contigs.fasta | wc -l
grep '>' /home/ibab/BDBP307/20260723_1_bacterial_genome_assembly/assembly/202607024_spades/K55/simplified_contigs.fasta | wc -l
grep '>' /home/ibab/BDBP307/20260723_1_bacterial_genome_assembly/assembly/202607024_spades/K33/simplified_contigs.fasta | wc -l
grep '>' /home/ibab/BDBP307/20260723_1_bacterial_genome_assembly/assembly/202607024_spades/K21/simplified_contigs.fasta | wc -l

#k_55
mkdir k_55
spades.py -1 SRR8389900_1_val_1.fq -2 SRR8389900_2_val_2.fq -t 20 -m 10 -k 55 --cov-cutoff auto -o /home/ibab/BDBP307/20260723_1_bacterial_genome_assembly/assembly/202607024_spades/k_55
grep '>' /home/ibab/BDBP307/20260723_1_bacterial_genome_assembly/assembly/202607024_spades/k_55/contigs.fasta | wc -l
grep '>' /home/ibab/BDBP307/20260723_1_bacterial_genome_assembly/assembly/202607024_spades/k_55/scaffolds.fasta | wc -l

#quast
python3 /home/ibab/BDBP307/packages/quast/quast.py /home/ibab/BDBP307/20260723_1_bacterial_genome_assembly/assembly/202607024_spades/scaffolds.fasta /home/ibab/BDBP307/20260723_1_bacterial_genome_assembly/assembly/202607024_spades/contigs.fasta -o /home/ibab/BDBP307/20260723_1_bacterial_genome_assembly/quality_stats

#combined quast report
python3 /home/ibab/BDBP307/packages/quast/quast.py /home/ibab/BDBP307/20260723_1_bacterial_genome_assembly/assembly/202607024_spades/scaffolds.fasta /home/ibab/BDBP307/20260723_1_bacterial_genome_assembly/assembly/202607024_spades/contigs.fasta /home/ibab/BDBP307/20260723_1_bacterial_genome_assembly/assembly/202607024_spades/k_55/contigs.fasta /home/ibab/BDBP307/20260723_1_bacterial_genome_assembly/assembly/202607024_spades/k_55/scaffolds.fasta -o /home/ibab/BDBP307/20260723_1_bacterial_genome_assembly/quality_stats/contigs_scaffolds_optimal_k_55/


