# DDP Finetuning

Distributed fine-tuning of LLMs on a Slurm/Kubernetes cluster provisioned on [Nebius AI](https://nebius.com).

## Infrastructure

Terraform configs to spin up a Slurm cluster (via [soperator](https://github.com/nebius/soperator)) on Nebius:

```bash
source .envrc       # set up env vars and Terraform backend
terraform init
terraform apply
```

## Training

Submit a fine-tuning job via Slurm:

```bash
sbatch run-finetuning-gpu1.sh --model meta-llama/Llama-3.1-8B
sbatch run-finetuning-gpu16.sh --model meta-llama/Llama-3.1-8B --peft
```

## Login

```bash
./login.sh -k ~/.ssh/id_rsa -a <login_node_ip>
```
