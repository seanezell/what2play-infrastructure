const { DynamoDBClient } = require('@aws-sdk/client-dynamodb');
const { DynamoDBDocumentClient, PutCommand } = require('@aws-sdk/lib-dynamodb');

const dynamoClient = DynamoDBDocumentClient.from(new DynamoDBClient());

exports.handler = async (event) => {
    console.log('Post-confirmation event:', JSON.stringify(event, null, 2));
    
    try {
        const userId = event.request.userAttributes.sub;
        const email = event.request.userAttributes.email;
        
        // Generate temporary username from user ID
        const tempUsername = `user_${userId.substring(0, 8)}`;
        
        // Create user profile
        await createUserProfile(userId, tempUsername, email);
        
        console.log(`Profile created for user: ${userId}`);
        return event;
        
    } catch (error) {
        console.error('Error creating user profile:', error);
        // Don't fail the registration process
        return event;
    }
};

async function createUserProfile(userId, username, email) {
    const now = new Date().toISOString();
    
    // Create profile record
    const profileParams = {
        TableName: 'what2play',
        Item: {
            PK: `USER#${userId}`,
            SK: 'PROFILE',
            username,
            real_name: '',
            email,
            preferred_platform: 'PC',
            profile_complete: false,
            created_date: now,
            updated_date: now
        }
    };
    
    // Create username index record
    const usernameParams = {
        TableName: 'what2play',
        Item: {
            PK: `USERNAME#${username.toLowerCase()}`,
            SK: `USER#${userId}`,
            GSI1PK: `USERNAME#${username.toLowerCase()}`,
            GSI1SK: `USER#${userId}`,
            created_date: now
        }
    };
    
    await Promise.all([
        dynamoClient.send(new PutCommand(profileParams)),
        dynamoClient.send(new PutCommand(usernameParams))
    ]);
}