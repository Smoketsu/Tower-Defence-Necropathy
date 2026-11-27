#!/bin/sh
# web_music.sh: copies the per-map songs beside the Web build (DECISIONS P1). The Web export leaves
# assets/audio/music/ out of index.pck (export_presets.cfg exclude_filter); the game fetches
# <build_dir>/music/<map>.ogg when a run starts (Sfx._songs_fetched(), SoundData.SONG_WEB_DIR).
# Usage: sh tools/web_music.sh [build_dir]   (default build/web; run after the export)
set -e
dir="${1:-build/web}"
mkdir -p "$dir/music"
cp assets/audio/music/*.ogg "$dir/music/"
echo "web_music: $(ls "$dir/music" | wc -l) songs copied to $dir/music/"
