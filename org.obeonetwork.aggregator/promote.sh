#!/bin/sh

[ -z "$BUILD_TYPE" -o -z "$WORKSPACE" ] && {
     echo "Execution aborted.

One or more of the required variables is not set. They are normally
provided by the Hudson build.

- BUILD_TYPE  : Should be N, R or S (for Nightly, Release or Stable
- WORKSPACE      : the build workspace root.
"
    exit 1
}

export OD_VERSION="od62"


export PROMOTION_ROOT="/Shares/DOCUMENTS/partage/logiciels/obeo/bundles/network/wagon/integration/updates/$OD_VERSION"
if [ $BUILD_TYPE='R' ];
then
  export PROMOTION_ROOT="/Shares/DOCUMENTS/partage/logiciels/obeo/bundles/network/wagon/livraison/$OD_VERSION"
fi
if [ $BUILD_TYPE='S' ];
then
  export PROMOTION_ROOT="/Shares/DOCUMENTS/partage/logiciels/obeo/bundles/network/wagon/stable/$OD_VERSION"
fi


######################################################################
# Setup
######################################################################

# Exit on error
set -e
echo "BUILD_TYPE is : $BUILD_TYPE"
echo "Destination is : $PROMOTION_ROOT"

# Remove the target file if any 
ssh integration@fileserver rm -Rf "$PROMOTION_ROOT"
# Create a file "viewpointChangesURL.txt" that contains the URL of the page that displays Viewpoint changes contents for this p2 repository
ssh integration@fileserver mkdir -p "$PROMOTION_ROOT"
scp -r "$WORKSPACE/org.obeonetwork.aggregator/result/final/" "integration@fileserver:$PROMOTION_ROOT/"
