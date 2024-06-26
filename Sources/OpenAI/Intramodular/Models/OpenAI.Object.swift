//
// Copyright (c) Vatsal Manot
//

import NetworkKit
import Swift

extension OpenAI {
    public enum ObjectType: String, Codable, TypeDiscriminator, Sendable {
        case list
        case embedding
        case textCompletion = "text_completion"
        case chatCompletion = "chat.completion"
        case chatCompletionChunk = "chat.completion.chunk"
        case speech = "speech"
        case file = "file"
        case thread = "thread"
        case message = "thread.message"
        case assistant = "assistant"
        case assistantFile = "assistant.file"
        case run = "thread.run"
        
        public func resolveType() -> Any.Type {
            switch self {
                case .list:
                    return OpenAI.List<Object>.self
                case .embedding:
                    return OpenAI.Embedding.self
                case .textCompletion:
                    return OpenAI.TextCompletion.self
                case .chatCompletion:
                    return OpenAI.ChatCompletion.self
                case .chatCompletionChunk:
                    return OpenAI.ChatCompletionChunk.self
                case .speech:
                    return OpenAI.Speech.self
                case .file:
                    return OpenAI.File.self
                case .thread:
                    return OpenAI.Thread.self
                case .message:
                    return OpenAI.Message.self
                case .assistant:
                    return OpenAI.Assistant.self
                case .assistantFile:
                    return OpenAI.AssistantFile.self
                case .run:
                    return OpenAI.Run.self
            }
        }
    }
}

extension OpenAI {
    public class Object: Codable, PolymorphicDecodable, TypeDiscriminable, @unchecked Sendable {
        private enum CodingKeys: String, CodingKey {
            case type = "object"
        }
        
        public let type: ObjectType
        
        public var typeDiscriminator: ObjectType {
            type
        }
        
        public init(type: ObjectType) {
            self.type = type
        }
        
        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.type = try container.decode(ObjectType.self, forKey: .type)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(type, forKey: .type)
        }
    }
}

extension OpenAI {
    public struct Usage: Codable, Hashable, Sendable {
        public let promptTokens: Int
        public let completionTokens: Int?
        public let totalTokens: Int
    }
}
