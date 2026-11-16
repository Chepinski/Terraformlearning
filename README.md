*only adding to git after successful create and destroy in AWS
1. First attempt at this was not very difficult but there were some issues with accuracy.
    a. I learned that tags needs an "=" because it is an argument for the resource and not a tag. 
    b. Also filter is part of the data block and shouldn't be made a block of its own.
2. Adding Security group
    a. If no egress added, Terraform will delete the default outbound rule that AWS usually adds.
    b. Keeping with "DRY" principle, port 8080 can be made into a variable.
