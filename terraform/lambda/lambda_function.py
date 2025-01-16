import json
import boto3

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('my-cloud-resume-view')

def lambda_handler(event, context):
    try:
        action = event.get('action')
        if action == 'increment':
            response = table.get_item(
                Key={
                    'id': '0'
                    })
            views = response['Item']['views']
            views = views + 1
        
            response = table.put_item(
                Item={
                    'id': '0', 
                    'views': views
                    }
            )

            return views
        else:
            response = table.get_item(
                Key={
                    'id': '0'
                }
            )
            views = response['Item']['views']
            return views
    except Exception as e:
        print(f"Error: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }