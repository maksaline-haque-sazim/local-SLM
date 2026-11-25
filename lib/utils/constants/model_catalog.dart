import 'package:flutter_getx_starter_template/domain/entitys/slm_model_entity.dart';

/// Models offered for download. All are 4-bit (Q4_K_M) GGUF files hosted on
/// Hugging Face; sizes are the exact byte counts reported by the host.
class ModelCatalog {
  ModelCatalog._();

  static const List<SlmModelEntity> models = [
    SlmModelEntity(
      id: 'smollm2-135m',
      name: 'SmolLM2 135M',
      family: 'SmolLM2',
      parameters: '135M',
      fileName: 'SmolLM2-135M-Instruct-Q4_K_M.gguf',
      url: 'https://huggingface.co/bartowski/SmolLM2-135M-Instruct-GGUF/resolve/main/SmolLM2-135M-Instruct-Q4_K_M.gguf',
      sizeBytes: 105454432,
    ),
    SlmModelEntity(
      id: 'smollm2-360m',
      name: 'SmolLM2 360M',
      family: 'SmolLM2',
      parameters: '360M',
      fileName: 'SmolLM2-360M-Instruct-Q4_K_M.gguf',
      url: 'https://huggingface.co/bartowski/SmolLM2-360M-Instruct-GGUF/resolve/main/SmolLM2-360M-Instruct-Q4_K_M.gguf',
      sizeBytes: 270590880,
    ),
    SlmModelEntity(
      id: 'qwen3-0.6b',
      name: 'Qwen3 0.6B',
      family: 'Qwen3',
      parameters: '0.6B',
      fileName: 'Qwen3-0.6B-Q4_K_M.gguf',
      url: 'https://huggingface.co/unsloth/Qwen3-0.6B-GGUF/resolve/main/Qwen3-0.6B-Q4_K_M.gguf',
      sizeBytes: 396705472,
    ),
    SlmModelEntity(
      id: 'gemma3-1b',
      name: 'Gemma 3 1B',
      family: 'Gemma 3',
      parameters: '1B',
      fileName: 'gemma-3-1b-it-Q4_K_M.gguf',
      url: 'https://huggingface.co/ggml-org/gemma-3-1b-it-GGUF/resolve/main/gemma-3-1b-it-Q4_K_M.gguf',
      sizeBytes: 806058240,
    ),
    SlmModelEntity(
      id: 'smollm2-1.7b',
      name: 'SmolLM2 1.7B',
      family: 'SmolLM2',
      parameters: '1.7B',
      fileName: 'SmolLM2-1.7B-Instruct-Q4_K_M.gguf',
      url: 'https://huggingface.co/bartowski/SmolLM2-1.7B-Instruct-GGUF/resolve/main/SmolLM2-1.7B-Instruct-Q4_K_M.gguf',
      sizeBytes: 1055609824,
    ),
    SlmModelEntity(
      id: 'qwen3-1.7b',
      name: 'Qwen3 1.7B',
      family: 'Qwen3',
      parameters: '1.7B',
      fileName: 'Qwen3-1.7B-Q4_K_M.gguf',
      url: 'https://huggingface.co/unsloth/Qwen3-1.7B-GGUF/resolve/main/Qwen3-1.7B-Q4_K_M.gguf',
      sizeBytes: 1107409472,
    ),
  ];

  static SlmModelEntity? byId(String? id) {
    for (final model in models) {
      if (model.id == id) {
        return model;
      }
    }
    return null;
  }
}
