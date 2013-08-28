#!/bin/bash
#
# Simple script for provisioning a virtual machine with puppet

PUPPET=`which puppet`
UNZIP=`which unzip`

fail_and_exit() {
	echo "Provisioning failed"
	exit 1
}

pushd /root
  # extract our puppet files
	$UNZIP -o master.zip || fail_and_exit

	pushd jidoteki-examples-master/atlassian-stash/provisioning || fail_and_exit
		# run puppet in standalone mode
		$PUPPET apply --modulepath=modules/ manifests/site.pp || fail_and_exit
	popd
popd

echo "Provisioning completed successfully"
exit 0