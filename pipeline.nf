#!/usr/bin/env nextflow

params.fastq = "/Users/dhusiakalyani/flowQC/NextflowQC/fastq/*.fastq.gz"

process QC {
    input:
    path fastq 

    output:
    path "*"

    script:
    """
    fastqc $fastq
    """
}

workflow {
    fastq_ch=Channel.fromPath(params.fastq) 
    QC(fastq_ch)
    QC.out.view()
}