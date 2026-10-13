# MuScriptor model-weight license

Simple Sampler's source tree and GitHub Actions artifact do not contain MuScriptor model weights.

At runtime, the existing NeuralNote downloader can fetch pinned GGUF files from
[`DamRsn/muscriptor-gguf`](https://huggingface.co/DamRsn/muscriptor-gguf). Those files are conversions of MuScriptor
weights released by Kyutai and Mirelo under
[Creative Commons Attribution-NonCommercial 4.0 International](https://creativecommons.org/licenses/by-nc/4.0/).
They may be used only under that license, including its attribution and noncommercial restrictions.

The repository's Apache-2.0 license applies to the NeuralNote-derived code, not to downloaded model weights. Building,
distributing, or selling the plugin binary does not grant commercial-use rights to the weights. Anyone planning a
commercial product must obtain appropriate model rights independently or replace the model with one whose license
permits that use.

The downloader pins a repository revision, expected byte sizes, and SHA-256 digests in
`Lib/Model/ModelManifest.h`; a mismatched download is rejected.
