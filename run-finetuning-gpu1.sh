#!/bin/bash

#SBATCH --job-name=llm_finetune
#SBATCH --partition=main
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --time=0:15:00
#SBATCH --gres=gpu:1

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

srun torchrun --standalone \
     --nnodes=1 \
     --nproc-per-node=1 \
     finetuning.py $* \
     --output-path $OUTPUT_DIR \
     --num-workers 10
