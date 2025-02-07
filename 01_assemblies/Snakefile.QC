
SAMPLES = ["AB-133", "BC-01_3rdrun", "BC-01", "BC-06", "BC-126", "BC-14", "MN-5", "OH-1", "ON-143", "OR-9", "PA-19A", "QC-157", "TN-1", "WI-244", "WV-2"] 


import os
os.environ["PATH"] += ":/nfs7/BPP/Weisberg_Lab/lab_members/zaccaron/programs/"



rule all:
   input:
      expand("output/01nanoplot/{sample}/NanoStats.txt", sample=SAMPLES),
      expand("output/02chopper/{sample}_rebasecall_sup5_QCd.fastq.gz", sample=SAMPLES),
      expand("output/03nanoplot/{sample}/NanoStats.txt", sample=SAMPLES),


# call nanoplot to check raw reads
rule nanoplot0:
   input:
      fastq="data/{sample}_rebasecall_sup5.fastq.gz"
   output:
      "output/01nanoplot/{sample}/NanoStats.txt"
   shell: """
      eval "$(/nfs7/BPP/Weisberg_Lab/lab_members/zaccaron/miniforge3/condabin/conda shell.bash hook)"
      conda activate nanoplot

      NanoPlot -t 16 \
         --fastq {input} \
         --outdir output/01nanoplot/{wildcards.sample}
   """



# call chopper to filter reads
rule chopper:
   input:
      fastq="data/{sample}_rebasecall_sup5.fastq.gz"
   output:
      "output/02chopper/{sample}_rebasecall_sup5_QCd.fastq.gz"
   params:
      minq=12,      # minimum average quality
      minlen=1000   # minimum read length
   shell: """
      gunzip -c {input} | \
         chopper --threads 16 -q {params.minq} -l {params.minlen} 2> {output}.log | gzip > {output}
   """



# call nanoplot once more to check filtered reads
rule nanoplot1:
   input:
      fastq="output/02chopper/{sample}_rebasecall_sup5_QCd.fastq.gz"
   output:
      "output/03nanoplot/{sample}/NanoStats.txt"
   shell: """
      eval "$(/nfs7/BPP/Weisberg_Lab/lab_members/zaccaron/miniforge3/condabin/conda shell.bash hook)"
      conda activate nanoplot

      NanoPlot -t 16 \
         --fastq {input} \
         --outdir output/03nanoplot/{wildcards.sample}
   """
