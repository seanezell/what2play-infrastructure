const mockSend = jest.fn();
const mockPutCommandCtor = jest.fn((input) => ({ input }));

jest.mock('@aws-sdk/client-dynamodb', () => ({
  DynamoDBClient: jest.fn(() => ({})),
}));

jest.mock('@aws-sdk/lib-dynamodb', () => ({
  DynamoDBDocumentClient: {
    from: jest.fn(() => ({
      send: mockSend,
    })),
  },
  PutCommand: function PutCommand(input) {
    return mockPutCommandCtor(input);
  },
}));

const { handler } = require('./index');

describe('post-confirmation lambda', () => {
  beforeEach(() => {
    jest.clearAllMocks();
    process.env.TABLE_NAME = 'what2play-test';
    mockSend.mockResolvedValue({});
  });

  it('returns original event and writes profile + username records', async () => {
    const event = {
      request: {
        userAttributes: {
          sub: 'abcdef12-3456-7890-abcd-ef1234567890',
          email: 'test@example.com',
        },
      },
    };

    const result = await handler(event);

    expect(result).toBe(event);
    expect(mockPutCommandCtor).toHaveBeenCalledTimes(2);
    expect(mockSend).toHaveBeenCalledTimes(2);

    const firstCallInput = mockPutCommandCtor.mock.calls[0][0];
    const secondCallInput = mockPutCommandCtor.mock.calls[1][0];

    expect(firstCallInput.TableName).toBe('what2play-test');
    expect(firstCallInput.Item.PK).toBe('USER#abcdef12-3456-7890-abcd-ef1234567890');
    expect(firstCallInput.Item.SK).toBe('PROFILE');
    expect(firstCallInput.Item.email).toBe('test@example.com');
    expect(firstCallInput.Item.username).toBe('user_abcdef12');

    expect(secondCallInput.TableName).toBe('what2play-test');
    expect(secondCallInput.Item.PK).toBe('USERNAME#user_abcdef12');
    expect(secondCallInput.Item.SK).toBe('USER#abcdef12-3456-7890-abcd-ef1234567890');
    expect(secondCallInput.Item.GSI1PK).toBe('USERNAME#user_abcdef12');
    expect(secondCallInput.Item.GSI1SK).toBe('USER#abcdef12-3456-7890-abcd-ef1234567890');
  });

  it('throws when dynamodb write fails', async () => {
    mockSend.mockRejectedValueOnce(new Error('dynamo write failed'));

    const event = {
      request: {
        userAttributes: {
          sub: 'abcdef12-3456-7890-abcd-ef1234567890',
          email: 'test@example.com',
        },
      },
    };

    await expect(handler(event)).rejects.toThrow('dynamo write failed');
  });
});
