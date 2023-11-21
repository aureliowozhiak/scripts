#!/bin/bash

# Check the current status of the EC2 instance
status=$(aws ec2 describe-instances --instance-ids i-08bce359f12fcb4fd --query 'Reservations[0].Instances[0].State.Name' --output text)

# Parse the output to extract the instance status
case $status in
    running)
        echo "The instance is already running."
        # Turn off the instance
        aws ec2 stop-instances --instance-ids i-08bce359f12fcb4fd
        echo "The instance has been turned off."
        ;;
    stopped)
        # Turn on the instance
        aws ec2 start-instances --instance-ids i-08bce359f12fcb4fd
        echo "The instance has been turned on."
        #wait for the instance to start
        aws ec2 wait instance-running --instance-ids i-08bce359f12fcb4fd
        echo "The instance is now running."
        # return the IP address of the instance
        aws ec2 describe-instances --instance-ids i-08bce359f12fcb4fd --query 'Reservations[0].Instances[0].PublicIpAddress' --output text
        ;;
    pending|stopping)
        echo "The instance is currently transitioning and cannot be turned on."
        ;;
    terminated)
        echo "The instance no longer exists."
        ;;
    *)
        echo "The instance is in an unknown state."
        ;;
esac
