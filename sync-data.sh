#-----------------GLOBAL VARIABLES 
PRODUCTION_DIR="/var/local/copernicus/land.copernicus.plonebuildout"
STAGING_DIR="/var/local/copernicus/staging/land.copernicus.plonebuildout"
#----------------------------

#----------------GENERAL FUNCTIONS
log() {
    echo "$(date)-->$1"
}

remove_dir() {
    if [ -d "$1" ]; then
        rm -rf "$1"
        if [ "$?" -ne "0" ]; then
            log "Can't remove $1 folder"
            exit 1
        fi
    fi
}
#----------------MAIN 
#Assumed that exists filestorage and blobstorage folders

log "Starting sync script"

$STAGING_DIR/bin/supervisorctl stop all
if [ "$?" -ne "0" ]; then
    log "Can't stop all from supervisorctl"
    exit 1
fi

remove_dir "$STAGING_DIR/var/filestorage"
cp -r $PRODUCTION_DIR/var/filestorage $STAGING_DIR/var/
if [ "$?" -ne "0" ]; then
    echo "Can't copy filestorage"
    exit 1
fi

remove_dir "$STAGING_DIR/var/blobstorage"
cp -r $PRODUCTION_DIR/var/blobstorage $STAGING_DIR/var/
if [ "$?" -ne "0" ]; then
    echo "Can't copy blobstorage"
    exit 1
fi

$STAGING_DIR/bin/supervisorctl start all
if [ "$?" -ne "0" ]; then
    log "Can't start all from supervisorctl"
    exit 1
fi

log "Synchronisation done with success"
