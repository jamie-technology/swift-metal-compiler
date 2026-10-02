# swift-gpu — compiler patch overlay

A patch set that teaches the Swift compiler to emit **Apple AIR** (Metal GPU
bitcode), so you can write Metal compute kernels in Swift. It is the compiler
half of [swift-metal-lib](https://github.com/jamie-technology/swift-metal-lib)
— the `MetalSwift` runtime library, the `Textures`/`Atomics` packages, the
examples, and the full design docs live there.

This repo is **not** a full fork of apple/swift. It is a single patch applied on
top of a pinned upstream commit, so there is no multi-gigabyte vendored tree to
clone — just the ~1,800 lines that are actually ours.

## What it adds

- `@Compute` kernels plus parameter attributes (`@ThreadPositionInGrid` and
  siblings, `@Binding(to: N)`), emitted as `!swiftgpu.kernels` metadata.
- Address-space type qualifiers (`@Device`/`@Constant`/`@Threadgroup`/`@Thread`)
  lowered to AIR address spaces (device=1, constant=2, threadgroup=3, thread=0).
- `-emit-air` / `-emit-metallib` front-end paths: AIR normalization, typed
  (non-opaque) pointer reconstruction, and `metal-as` + `metallib` packaging.
- Constant/threadgroup global data, textures (the `Textures` package type lowers
  with no dedicated IRGen), atomics, and `uint3` 3D dispatch.
- Three-layer **GPU-safe subset** enforcement: AST signature/body checks, a
  pre-`-O` SIL call-graph check (recursion + heap), and a post-`-O` backstop that
  rejects unresolvable runtime dependencies.

The full file-by-file rationale is in
[`docs/fork-changes.md`](https://github.com/jamie-technology/swift-metal-lib/blob/main/docs/fork-changes.md)
of the library repo.

## Base

See [`BASE_COMMIT`](./BASE_COMMIT). The patch is generated against apple/swift:

```
commit 83c32e02f71e4bbe5745f326cc1276f0c721e625
snapshot swift-DEVELOPMENT-SNAPSHOT-2026-06-24-a
```

Only the `swift` repo is patched — no changes to `llvm-project`, `swift-syntax`,
`cmark`, or any other repo in the checkout.

## Apply & build

1. Get an apple/swift checkout at the pinned commit (e.g. via `update-checkout`
   with the snapshot tag above, or `git checkout 83c32e02f71` in an existing
   `swift` repo).
2. Apply the patch and build `swift-frontend`:

   ```sh
   ./apply.sh /path/to/your/swift
   BUILD=/path/to/your/build/.../swift-macosx-arm64 ./build.sh
   ```

   `apply.sh` warns if the checkout isn't at the pinned base (expect fuzz or
   rejects against a different commit). `build.sh` just runs the standard Ninja
   `bin/swift-frontend` target; point `BUILD` at your build tree.

## Layout

| Path | What |
| --- | --- |
| `swift-gpu.patch` | the entire change set (61 files, `git apply`-able) |
| `apply.sh` | apply the patch to a `swift` checkout |
| `build.sh` | build `swift-frontend` |
| `BASE_COMMIT` | the pinned apple/swift base |
