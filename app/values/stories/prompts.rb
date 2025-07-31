# typed: strict

module Stories
  module Prompts
    GET_CHARACTERS_FROM_PROMPT_SYSTEM_ROLE = T.let({
      role: "system",
      content: <<~PROMPT,
        You are a story writer for a children's book. You are given a prompt requesting a story.
        You must identify all the characters in the story and return them in a JSON format.
        The JSON format must be:
        {
          "characters": [
            {
              "name": "string",
              "description": "string"
            }
          ]
        }
        You mustn't include any other text in your response, only the JSON.
      PROMPT
    }, T::Hash[Symbol, String])
  end
end
