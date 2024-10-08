#!/bin/sh

set -e pipefail

command -v reviewdog >/dev/null 2>&1 || { echo >&2 "reviewdog: not found"; exit 1; }

{ echo "Pre-installed"; java -jar /opt/lib/checkstyle.jar --version; } | sed ':a;N;s/\n/ /;ba'

if [ -n "${GITHUB_WORKSPACE}" ] ; then
  cd "${GITHUB_WORKSPACE}" || exit
  git config --global --add safe.directory "${GITHUB_WORKSPACE}" || exit 1
fi

if [ -n "${INPUT_PROPERTIES_FILE}" ]; then
  OPTIONAL_PROPERTIES_FILE="-p ${INPUT_PROPERTIES_FILE}"
fi

if [ -n "${IMPUT_EXCLUDED_PATHDS}" ]; then
  OPTIONAL_EXCLUDED_PATHS="-x ${IMPUT_EXCLUDED_PATHDS}"
fi

# user wants to use custom checkstyle version, try to install it
if [ -n "${INPUT_CHECKSTYLE_VERSION}" ]; then
  url="https://github.com/checkstyle/checkstyle/releases/download/checkstyle-${INPUT_CHECKSTYLE_VERSION}/checkstyle-${INPUT_CHECKSTYLE_VERSION}-all.jar"

  echo "Custom Checkstyle version has been configured: 'v${INPUT_CHECKSTYLE_VERSION}', try to download from ${url}"
  wget -q -O /opt/lib/checkstyle.jar "$url"
fi

if [ "${INPUT_USE_CUSTOM_VALIDATIONS}" = "true" ]; then
  if [ -z "${INPUT_CUSTOM_VALIDATIONS}" ]; then
    echo "Custom Checkstyle validator has been configured but no value was provided"
    exit 1
  fi
  CHECK_STYLE_CLASS_PATH="-classpath /opt/lib/checkstyle.jar:${INPUT_CUSTOM_VALIDATIONS}"
else
  CHECK_STYLE_CLASS_PATH="-classpath /opt/lib/checkstyle.jar"
fi

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

# run check
{ echo "Run check with"; java -jar /opt/lib/checkstyle.jar --version; } | sed ':a;N;s/\n/ /;ba'

echo "CHECK_STYLE_CLASS_PATH ${CHECK_STYLE_CLASS_PATH}"
echo "INPUT_CHECKSTYLE_CONFIG ${INPUT_CHECKSTYLE_CONFIG}"
echo "INPUT_WORKDIR ${INPUT_WORKDIR}"
echo "OPTIONAL_PROPERTIES_FILE ${OPTIONAL_PROPERTIES_FILE}"

echo "before exec"

echo "exec java \"${CHECK_STYLE_CLASS_PATH}\" \
  com.puppycrawl.tools.checkstyle.Main \"${INPUT_WORKDIR}\" \
  -c \"${INPUT_CHECKSTYLE_CONFIG}\" \"${OPTIONAL_PROPERTIES_FILE}\" \"${OPTIONAL_EXCLUDED_PATHS}\" -f xml \
  | reviewdog -f=checkstyle \
        -name=\"checkstyle\" \
        -reporter=\"${INPUT_REPORTER:-github-pr-check}\" \
        -filter-mode=\"${INPUT_FILTER_MODE:-added}\" \
        -fail-on-error=\"${INPUT_FAIL_ON_ERROR:-false}\" \
        -level=\"${INPUT_LEVEL}\" \
        \"${INPUT_REVIEWDOG_FLAGS}\" -"

echo "after exec"

exec java "${CHECK_STYLE_CLASS_PATH}" \
  com.puppycrawl.tools.checkstyle.Main "${INPUT_WORKDIR}" \
  -c "${INPUT_CHECKSTYLE_CONFIG}" "${OPTIONAL_PROPERTIES_FILE}" "${OPTIONAL_EXCLUDED_PATHS}" -f xml \
  | reviewdog -f=checkstyle \
        -name="checkstyle" \
        -reporter="${INPUT_REPORTER:-github-pr-check}" \
        -filter-mode="${INPUT_FILTER_MODE:-added}" \
        -fail-on-error="${INPUT_FAIL_ON_ERROR:-false}" \
        -level="${INPUT_LEVEL}" \
        "${INPUT_REVIEWDOG_FLAGS}" -