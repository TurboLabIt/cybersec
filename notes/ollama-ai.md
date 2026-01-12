Ollama (AI) runs on `11434` (default).


## attacker setup

````shell
sudo apt update && sudo apt install curl jq -y
````


## detection
````shell
$ curl -s http://127.0.0.1:11434/

Ollama is running
````


## list the models

````shell
$ curl -s http://127.0.0.1:11434/api/tags | jq

{
  "models": [
    {
      "name": "sir-carrotbane:latest",
      "model": "sir-carrotbane:latest",
      "modified_at": "2025-11-20T17:48:43.451282683Z",
      "size": 522654619,
      "digest": "30b3cb05e885567e4fb7b6eb438f256272e125f2cc813a62b51eb225edb5895e",
      "details": {
        "parent_model": "",
        "format": "gguf",
        "family": "qwen3",
        "families": [
          "qwen3"
        ],
        "parameter_size": "751.63M",
        "quantization_level": "Q4_K_M"
      }
    },
    {
      "name": "qwen3:0.6b",
      "model": "qwen3:0.6b",
      "modified_at": "2025-11-20T17:41:39.825784759Z",
      "size": 522653767,
      "digest": "7df6b6e09427a769808717c0a93cadc4ae99ed4eb8bf5ca557c90846becea435",
      "details": {
        "parent_model": "",
        "format": "gguf",
        "family": "qwen3",
        "families": [
          "qwen3"
        ],
        "parameter_size": "751.63M",
        "quantization_level": "Q4_K_M"
      }
    }
  ]
}
````


## show the details of one model

````shell
$ curl -s http://127.0.0.1:11434/api/show -d '{
  "name": "sir-carrotbane"
}'  | jq
````
