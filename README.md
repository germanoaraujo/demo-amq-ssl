# AMQ 7.4

Example on how to run AMQ 7.4 using source to image

## How to Run

    oc new-app registry.redhat.io/amq7/amq-broker:7.4~https://gitlab.com/GuilhermeCamposo/amq74.git -e AMQ_USER=teste -e AMQ_PASSWORD=teste
