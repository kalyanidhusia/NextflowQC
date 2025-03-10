#!/usr/bin/env nextflow

// Parameters definition
params.fastq = "/Users/dhusiakalyani/flowQC/NextflowQC/fastq/"
//params.index_dir = "/Users/dhusiakalyani/flowQC/NextflowQC/index_dir/"
params.ref_genome = "/Users/dhusiakalyani/flowQC/NextflowQC/index_dir/chr22_with_ERCC92.fa"

// Channels definition
ref_ch = Channel.value(params.ref_genome)
//fastq_ch = Channel.fromFilePairs("${params.fastq}{*_{read1,read2}.fastq.gz}", size: 2, flat: true)
fastq_ch = Channel.fromFilePairs("${params.fastq}*_read{1,2}.fastq.gz", size: 2, flat: true)

process mapping {
    tag "Mapping ${sample_id}"

    input:
    path ref_genome
    tuple val(sample_id), path(read1), path(read2)

    output:
    path "*.bam"

    script:
    """
    echo "Reference Genome: ${ref_genome}"
    echo "Read 1: ${read1}"
    echo "Read 2: ${read2}"
    bwa mem ${ref_genome} ${read1} ${read2} | samtools view -bh -o ${sample_id}.bam -
    """
}

workflow {
    // Execute the mapping process using the defined channels
    mapping(ref_ch, fastq_ch)
    mapping.out.view { it -> println("Generated BAM file: ${it}") }
}
