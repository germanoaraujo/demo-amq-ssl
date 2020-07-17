# AMQ 7.7

Example on how to run AMQ 7.7 using source to image

## How to Run

    oc new-app registry.redhat.io/amq7/amq-broker~https://github.com/germanoaraujo/demo-amq-ssl.git -e AMQ_USER=teste -e AMQ_PASSWORD=teste
