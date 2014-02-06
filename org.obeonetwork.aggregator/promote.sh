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


case "$BUILD_TYPE" in

R) export PROMOTION_ROOT="/Shares/DOCUMENTS/partage/logiciels/obeo/bundles/network/livraison/$OD_VERSION"
   export MARKETPLACE_LOCATION="/Shares/INTERNET/HTTP/PUBLIC/marketplace/updates/$OD_VERSION"
    ;;
S) export PROMOTION_ROOT="/Shares/DOCUMENTS/partage/logiciels/obeo/bundles/network/stable/$OD_VERSION"
   export MARKETPLACE_LOCATION="/Shares/INTERNET/HTTP/PUBLIC/marketplace/updates/milestones/$OD_VERSION"
    ;;
N) export PROMOTION_ROOT="/Shares/DOCUMENTS/partage/logiciels/obeo/bundles/network/integration/updates/$OD_VERSION"
   export MARKETPLACE_LOCATION="/Shares/INTERNET/HTTP/PUBLIC/marketplace/updates/nightly/$OD_VERSION"
    ;;
*) export PROMOTION_ROOT="/Shares/DOCUMENTS/partage/logiciels/obeo/bundles/network/integration/updates/$OD_VERSION"
   ;;
esac


######################################################################
# Setup
######################################################################

# Exit on error
set -e
echo "BUILD_TYPE is : $BUILD_TYPE"
echo "Intranet destination is : $PROMOTION_ROOT"
echo "Marketplace Destination is : $MARKETPLACE_LOCATION"


# Remove the target file if any 
ssh integration@dervallieres rm -Rf "$MARKETPLACE_LOCATION"
ssh integration@dervallieres mkdir -p "$MARKETPLACE_LOCATION"
(cd "$WORKSPACE/org.obeonetwork.aggregator/result/final/" ; scp -r . "integration@dervallieres:$MARKETPLACE_LOCATION/")

# Remove the target file if any 
ssh integration@fileserver rm -Rf "$PROMOTION_ROOT"
# Create a file "viewpointChangesURL.txt" that contains the URL of the page that displays Viewpoint changes contents for this p2 repository
ssh integration@fileserver mkdir -p "$PROMOTION_ROOT"
(cd "$WORKSPACE/org.obeonetwork.aggregator/result/final/" ; scp -r . "integration@fileserver:$PROMOTION_ROOT/")
