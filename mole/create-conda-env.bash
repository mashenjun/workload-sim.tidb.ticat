set -euo pipefail

here=`cd $(dirname ${BASH_SOURCE[0]}) && pwd`
. "${here}/../helper/helper.bash"

env=`cat "${1}/env"`

conda=`must_env_val "${env}" 'conda.bin'`
environment_requirements_yaml="${dir}/conda_env_linux.yaml"
if [ ! -f "${environment_requirements_yaml}" ]; then
		echo "[:(] can't find '${environment_requirements_yaml}'" >&2
		exit 1
fi 

${conda} env create -n workload-sim -f "${environment_requirements_yaml}"