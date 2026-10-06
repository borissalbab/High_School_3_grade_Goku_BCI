# High_School_3_grade_BCI_project_V1
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

## Main Concept_description

### 1. Real-time EEG Visualization

NeuroSky TGAM으로부터 실시간으로 EEG Attention 데이터를 수집하고,
Processing에서 이를 처리하여 집중도에 따라 손오공의 변신 단계가
변화하도록 구현했다.

Attention 값을 0~100의 범위로 활용하고, LERP 기반의 smoothing을
적용하여 순간적인 값의 변동을 줄였다.

### 2. Discovering the Importance of EEG Signal Filtering

프로젝트를 진행하면서 EEG Attention 값이 측정 환경과 신호 품질에
따라 불안정하게 변화할 수 있다는 점을 발견했다.

이에 단순히 Attention 값만 사용하는 것이 아니라 Signal Quality와
Beta Power를 함께 활용하여 Attention 값의 신뢰성을 판단할 수 있는
방법을 실험했다.
isReliableAttention() 함수를 통해서 실험을 했지만 실제 파이프라인이
연결되지 않아 필터링을 한 값이 반영이 되지 않는 오류를 2026/10/6 에 발견했다.


이 과정에서 EEG 데이터를 수집하는 것 자체보다, **수집된 신호에서
신뢰할 수 있는 정보를 추출하고 안정적으로 처리하는 과정이
BCI 시스템에서 매우 중요하다는 점**을 확인했다.


### 3. Pixel-level Image Interpolation

Attention 값을 0~1 범위로 정규화한 뒤 4개의 손오공 이미지에
매핑하였다.

인접한 두 이미지의 각 픽셀의 RGB 값을 선형 보간(Linear
Interpolation)하여 Attention 값의 변화에 따라 손오공의 변신이
부드럽게 이어지도록 구현했다.

## Features

- Real-time EEG Attention data parsing
- Attention value smoothing
- Four-stage Goku visualization
- Pixel-level image blending
- TGAM serial communication
