August 14 2026
Gatk
#variantFilteration
gatk VariantFiltration -R /home/ibab/BDBP307/20260811_Variant_calling/raw_fastq/chr20.fa -V /home/ibab/BDBP307/20260813/SRR15117878.vcf.gz --filter-expression "QD<2.0" --filter-name "LowQD" -O /home/ibab/BDBP307/20260814_gatk/SRR15117878_final.filtered.vcf

#grepping the lowQD
grep "LowQD" /home/ibab/BDBP307/20260814_gatk/SRR15117878_final.filtered.vcf

#selecting variant
gatk --java-options '-Xmx60g' SelectVariants -R /home/ibab/BDBP307/20260811_Variant_calling/raw_fastq/chr20.fa -V /home/ibab/BDBP307/20260813/SRR15117878.vcf.gz -select-type SNP -O SRR15117878_snp.vcf
#java option is for for memory xmx is maximum memory 

gatk --java-options '-Xmx60g' SelectVariants -R /home/ibab/BDBP307/20260811_Variant_calling/raw_fastq/chr20.fa -V /home/ibab/BDBP307/20260813/SRR15117878.vcf.gz -select-type INDEL -O SRR15117878_indel.vcf

#upstream process over

#annotation
/home/ibab/BDBP307/packages/annovar/convert2annovar.pl -format vcf4 /home/ibab/BDBP307/20260813/SRR15117878.vcf.gz -outfile SRR15117878_annovar_final.avinput -includeinfo

/home/ibab/BDBP307/packages/annovar/table_annovar.pl /home/ibab/BDBP307/20260814_gatk/SRR15117878_annovar_final.avinput /home/ibab/BDBP307/packages/annovar/humandb -buildver hg19 -out SRR15117878_FINAL -protocol refGene -operation g -nastring .
#table annovar file path ; input; ref genome path option -out fileName (.) very necessary [saved in working directory]----------------protocol has what info to be used ----[-g overall file]
#6 file output 

#variant calling using freebayes
freebayes -f /home/ibab/BDBP307/20260811_Variant_calling/raw_fastq/chr20.fa /home/ibab/BDBP307/20260811_Variant_calling/alignment/SRR15117878_markdup.bam > SRR15117878_VARIANTSfreebayes.vcf
freebayes -f ref.fa input.bam > output.bam

