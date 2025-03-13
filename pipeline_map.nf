#!/usr/bin/env nextflow

// Parameters definition
params.index_dir = "/Users/dhusiakalyani/flowQC/NextflowQC/ref"
params.ref ="chr22_with_ERCC92.fa"
params.fastq = "/Users/dhusiakalyani/flowQC/NextflowQC/fastq/*_{read1,read2}*"

params.bam = "/Users/dhusiakalyani/flowQC/NextflowQC/BAM"

process mapping {

publishDir("${params.bam}", mode: 'copy')

input:
    path index_dir
    val ref
    tuple val (sample_id), path(fastq)

output:
    path "*"

script:
    """
    echo "Reference Genome: ${ref}"
    echo "Reads : ${fastq}"
    bwa mem ${index_dir}/${ref} ${fastq} | samtools view -h -b -o ${sample_id}.bam -
    """
}

workflow {
// Execute the mapping process using the defined channels
index_ch = Channel.fromPath(params.index_dir)
ref_ch = Channel.of(params.ref)

//fastq_ch = Channel.fromFilePairs("${params.fastq}{*_{read1,read2}.fastq.gz}", size: 2, flat: true)
fastq_ch = Channel.fromFilePairs(params.fastq)

mapping(index_ch,ref_ch,fastq_ch)
mapping.out.view()
}
