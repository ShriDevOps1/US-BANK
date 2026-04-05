#!/usr/bin/env bash
# ============================================================
# trigger-infra.sh — Trigger a GitLab on-demand infra pipeline
#
# Usage:
#   ./scripts/trigger-infra.sh \
#     --env dev \
#     --infra aks \
#     --action apply \
#     [--nodes 3] \
#     [--vm-size Standard_D4s_v3] \
#     [--location eastus]
#
# Prerequisites:
#   export GITLAB_TOKEN=<your-personal-access-token>
#   export GITLAB_PROJECT_ID=<your-project-id>
#   export GITLAB_URL=https://gitlab.com   (or self-hosted URL)
# ============================================================

set -euo pipefail

# ── Defaults ─────────────────────────────────────────────────
ENVIRONMENT="dev"
INFRA_TYPE="all"
ACTION="plan"
AKS_NODE_COUNT="2"
AKS_VM_SIZE="Standard_D2s_v3"
LOCATION="eastus"
REF="main"

GITLAB_URL="${GITLAB_URL:-https://gitlab.com}"

# ── Arg parsing ───────────────────────────────────────────────
usage() {
  echo "Usage: $0 --env <dev|staging|prod> --infra <aks|acr|vnet|storage|all> --action <plan|apply|destroy> [options]"
  exit 1
}

while [[ $# -gt 0 ]]; do
  case $1 in
    --env)          ENVIRONMENT="$2";      shift 2 ;;
    --infra)        INFRA_TYPE="$2";       shift 2 ;;
    --action)       ACTION="$2";           shift 2 ;;
    --nodes)        AKS_NODE_COUNT="$2";   shift 2 ;;
    --vm-size)      AKS_VM_SIZE="$2";      shift 2 ;;
    --location)     LOCATION="$2";         shift 2 ;;
    --ref)          REF="$2";              shift 2 ;;
    -h|--help)      usage ;;
    *)              echo "Unknown option: $1"; usage ;;
  esac
done

# ── Validate required env vars ────────────────────────────────
: "${GITLAB_TOKEN:?Set GITLAB_TOKEN}"
: "${GITLAB_PROJECT_ID:?Set GITLAB_PROJECT_ID}"

echo ""
echo "========================================="
echo "  Triggering GitLab Infrastructure Pipeline"
echo "========================================="
echo "  Project  : ${GITLAB_PROJECT_ID}"
echo "  Ref      : ${REF}"
echo "  Env      : ${ENVIRONMENT}"
echo "  Infra    : ${INFRA_TYPE}"
echo "  Action   : ${ACTION}"
echo "  Nodes    : ${AKS_NODE_COUNT}"
echo "  VM Size  : ${AKS_VM_SIZE}"
echo "  Location : ${LOCATION}"
echo "========================================="
echo ""

RESPONSE=$(curl --silent --fail \
  --request POST \
  "${GITLAB_URL}/api/v4/projects/${GITLAB_PROJECT_ID}/pipeline" \
  --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
  --form "ref=${REF}" \
  --form "variables[][key]=ENVIRONMENT"    --form "variables[][value]=${ENVIRONMENT}" \
  --form "variables[][key]=INFRA_TYPE"     --form "variables[][value]=${INFRA_TYPE}" \
  --form "variables[][key]=ACTION"         --form "variables[][value]=${ACTION}" \
  --form "variables[][key]=AKS_NODE_COUNT" --form "variables[][value]=${AKS_NODE_COUNT}" \
  --form "variables[][key]=AKS_VM_SIZE"    --form "variables[][value]=${AKS_VM_SIZE}" \
  --form "variables[][key]=LOCATION"       --form "variables[][value]=${LOCATION}" \
)

PIPELINE_ID=$(echo "$RESPONSE" | python3 -c "import sys,json; print(json.load(sys.stdin)['id'])")
PIPELINE_URL=$(echo "$RESPONSE" | python3 -c "import sys,json; print(json.load(sys.stdin)['web_url'])")

echo "Pipeline triggered!"
echo "  ID  : ${PIPELINE_ID}"
echo "  URL : ${PIPELINE_URL}"
echo ""
echo "Open the URL above to monitor progress and approve manual gates."
