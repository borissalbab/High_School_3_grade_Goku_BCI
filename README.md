# High-School-3-grade-BCI-project-V1
goku image conversion

# Goku BCI

EEG Attention 데이터를 이용해 집중도에 따라
손오공의 이미지가 단계적으로 변화하는 프로젝트.

## Project Overview

- EEG Sensor: NeuroSky TGAM
- Development Environment: Processing
- Programming Language: Java (Processing)
- Input: Attention value from EEG
- Output: Goku transformation visualization

## How it works

TGAM
→ EEG Attention
→ Processing
→ Attention smoothing
→ Image interpolation
→ Goku transformation visualization

## Main Concept

Attention 값(0~100)을 정규화한 뒤,
4개의 Goku 이미지 사이를 선형 보간(Linear Interpolation)하여
집중도 변화에 따라 화면이 부드럽게 전환되도록 구현했다.

## Features

- Real-time EEG Attention data parsing
- Attention value smoothing
- Four-stage Goku visualization
- Pixel-level image blending
- TGAM serial communication
