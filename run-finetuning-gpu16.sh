#!/bin/bash

#SBATCH --job-name=llm_finetune
#SBATCH --partition=main
#SBATCH --nodes=2
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=56
#SBATCH --mem=0
#SBATCH --time=0:15:00
#SBATCH --gpus-per-node=8

# Activate conda shell environemnt
eval "$(/root/miniconda3/bin/conda shell.bash hook)"

# Activate conda environment
#source activate llm_training
conda activate llm_training

HOME="/opt/llm_finetuning"

# This will store all the Hugging Face cache such as downloaded models
# and datasets in the project's scratch folder
export HF_HOME="${HOME}/hf-cache"
mkdir -p $HF_HOME

# Path to where the trained model and logging data will go
OUTPUT_DIR="${HOME}/hf-data"
mkdir -p $OUTPUT_DIR

# Disable internal parallelism of huggingface's tokenizer since we
# want to retain direct control of parallelism options.
export TOKENIZERS_PARALLELISM=false

# Use main node for Rendezvous settings
RDZV_HOST=$(hostname)
RDZV_PORT=29400

set -xv  # print the command so that we can verify setting arguments correctly from the logs

srun torchrun \
     --rdzv_id=$SLURM_JOB_ID \
     --rdzv_backend=c10d \
     --rdzv_endpoint="$RDZV_HOST:$RDZV_PORT" \
     --nnodes=2 \
     --nproc-per-node=${SLURM_GPUS_PER_NODE} \
     finetuning.py $* \
     --output-path $OUTPUT_DIR \
     --num-workers 7 \
     --batch_size 32