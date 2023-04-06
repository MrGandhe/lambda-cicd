import boto3
import yaml

def lambda_handler(event, context):
    client = boto3.client('iam')
    with open('module/python/data.yaml') as f:
           data = yaml.load(f,Loader= yaml.FullLoader)

    userlist = data['Users']
    for users in userlist: 
        print(users)     
        response = client.create_user(
        UserName=users
         )
        print(response)

    grouplist = data['GroupAssignment']     
    for groups in grouplist:
        print (groups)
        group = client.create_group(
        GroupName=groups
         )
        print (group)
        for x in grouplist[groups]:

            usergroup = client.add_user_to_group(
            GroupName=groups,
            UserName=x
            )      
        
            print (usergroup)
