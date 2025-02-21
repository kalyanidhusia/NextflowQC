#!/usr/bin/env nextflow

params.fastq = "/Users/dhusiakalyani/flowQC/NextflowQC/fastq/*.fastq.gz"
params.qc_reports = "/Users/dhusiakalyani/flowQC/NextflowQC/fastqc_report"
 
process QC {

    publishDir("${params.qc_reports}", mode:'copy')

    input:
    path fastq 

    output:
    path "*"

    script:
    """
    fastqc $fastq
    """
}

process MultiQC {

    publishDir("${params.qc_reports}", mode:'copy')

    input:
    path fastqc_reports 

    output:
    path "*"

    script:
    """
    multiqc $fastqc_reports -o ${params.qc_reports}
    """
}

workflow {
fastq_ch = Channel.fromPath(params.fastq)
qc_out_ch = QC(fastq_ch)
multiqc_ch = qc_out_ch.collect()
MultiQC(multiqc_ch)
}