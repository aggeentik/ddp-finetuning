# DDP Finetuning

Distributed fine-tuning of LLMs across multiple GPUs using PyTorch DDP and Slurm.

## Scripts

**`finetuning.py`** — Main training script. Fine-tunes a Hugging Face causal LM on the IMDb dataset using `torchrun`. Supports LoRA (PEFT) and 4-bit quantization.

```bash
torchrun --nproc-per-node=8 finetuning.py --model meta-llama/Llama-3.1-8B --output-path ./output --peft
```

**`run-finetuning-gpu1.sh`** — Slurm job script for single-GPU training.

**`run-finetuning-gpu16.sh`** — Slurm job script for 16-GPU training.

```bash
sbatch run-finetuning-gpu1.sh --model EleutherAI/gpt-neo-1.3B
sbatch run-finetuning-gpu16.sh --model EleutherAI/gpt-neo-1.3B --peft
```

**`login.sh`** — SSH into a cluster login node.

```bash
./login.sh -k ~/.ssh/id_rsa -a <login_node_ip>
```

**`copy_artifacts.sh`** — Copies training artifacts off the cluster.

**`clean.sh`** — Cleans up training outputs.
