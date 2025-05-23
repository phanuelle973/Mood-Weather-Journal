#!/bin/bash

set -e  # Stop if any command fails

echo "🚀 Starting deployment..." | tee -a deploy.log
echo "Timestamp: $(date)" | tee -a deploy.log

echo "🧼 Cleaning previous builds..."
dotnet clean >> deploy.log

echo "🔨 Building Blazor WebAssembly app..."
dotnet publish -c Release /p:BlazorEnableProjectContentOutput=true >> deploy.log

echo "📦 Syncing to gh-pages branch..."
cp -a bin/Release/net8.0/publish/. gh-pages/

cd gh-pages || exit

echo "💾 Committing to gh-pages..." | tee -a ../deploy.log
git add . >> ../deploy.log
git commit -m "Deploy on $(date)" >> ../deploy.log || echo "Nothing to commit" >> ../deploy.log

echo "🌐 Pushing to GitHub Pages..." | tee -a ../deploy.log
git push origin gh-pages --force >> ../deploy.log

cd ..

echo "📂 Committing to main branch (code updates)..."
git add .
git commit -m "Update project source on $(date)" || echo "No main branch changes"

git push origin main

echo "🌍 Opening live site..."
open "https://phanuelle973.github.io/Mood-Weather-Journal/"

echo "✅ Deploy complete!"
