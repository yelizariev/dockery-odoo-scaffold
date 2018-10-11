#!/bin/bash


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "\n${RED}First we build the production image. It contains:${NC}\n"
echo -e "\t${GREEN}- Odoo Community Code${NC}"
echo -e "\t${GREEN}- Odoo Enterprise Code (if configured)${NC}"
echo -e "\t${GREEN}- Vendored modules${NC}"
echo -e "\t${GREEN}- Your project modules (\`src\` folder)${NC}"
echo -e "\t${GREEN}- Your further customizations from the Dockerfile${NC}\n"
docker build --tag "${IMAGE}:${ODOO_VERSION}" --arg "FROM_IMAGE=${FROM}:${ODOO_VERSION}" "${DIR}/../."

echo -e "\n${RED}Now we build the allrounder image atop the production image.\n"
echo -e "\t${GREEN}- Complements additional tools for local dev${NC}"
echo -e "\t${GREEN}- Remote build context maintained by XOE.${NC}"
echo -e "\t${GREEN}- Therefore, as dev image evolves, just rebuild.${NC}"
echo -e "\t${GREEN}- For details, visit: https://git.io/fA9xc${NC}\n"
docker-compose build odoo

echo -e "\n${RED}First time? Before you start, remeber to:${NC}\n"
echo -e "\t${GREEN}- vendor your module dependencies and adapt the Dockerfile to load them;${NC}"
echo -e "\t${GREEN}- apply patches to your local workdir: \`.scripts/run-patches.sh\`;${NC}"
echo -e "\t\t${GREEN}ATTENTION: Never commit patches: stash them away, when tempted.${NC}"
echo -e "\t\t${GREEN}They are already applied in the prod image.${NC}"
echo -e "\t${GREEN}- scaffold a module or place one into the src folder; ${NC}"
echo -e "\t${GREEN}- initialize Database by first \`docker-compose up odoo\`.${NC}\n"
