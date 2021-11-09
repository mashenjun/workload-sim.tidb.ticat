set -euo pipefail

here=`cd $(dirname ${BASH_SOURCE[0]}) && pwd`
. "${here}/../../helper/helper.bash"

env_file="${1}/env"
env=`cat "${env_file}"`

download_url=`must_env_val "${env}" 'conda.unpack.download-url'`
conda_env_dir = `must_env_val "${env}" 'conda.env-dir'`
conda_env_dir = `eval echo "${conda_env_dir}"`

if [[ -e "${conda_env_dir}/bin/python3"]]; then
    ver=`"${conda_env_dir}/bin/python3" --version`
	echo "[:)] workload-sim conda version is already installed, python version: ${ver}"
	exit 0
fi

download_to="${here}/workload-sim-env.tar.gz"
wget "${download_url}" -O "${download_to}"
mkdir -p "${conda_env_dir}" && tar -zxf "${download_to}" -C "${conda_env_dir}"
echo "conda.env-python=${conda_env_dir}/bin/python3" >> "${env_file}"