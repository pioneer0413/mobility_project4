# 배터리 SOC 추정 프로젝트 (3RC ECM + EKF)

## 프로젝트 개요

본 프로젝트는 **3RC 등가회로 모델(Equivalent Circuit Model, ECM)**과 **확장 칼만 필터(Extended Kalman Filter, EKF)**를 활용하여 리튬이온 배터리의 **SOC(State of Charge, 충전 상태)**를 추정하는 시스템을 구현한 것입니다.

## 주요 기능

- 3RC 등가회로 모델을 이용한 배터리 전압 모델링
- OCV(Open Circuit Voltage) 테스트 데이터 기반 파라미터 추출
- 확장 칼만 필터(EKF)를 이용한 실시간 SOC 추정
- MATLAB/Simulink 기반 시뮬레이션 환경

## 파일 구조

```
├── RC3_ECM.m                    # 3RC ECM 파라미터 추출 MATLAB 스크립트
├── RC3_ECM.slx                  # 3RC ECM Simulink 모델
├── RC3_EKF.slx                  # EKF 기반 SOC 추정 Simulink 모델
├── RC3_Parameter_Extract.m      # RC 파라미터 추출 스크립트
├── RC3_Parameter_Tuning.m       # RC 파라미터 튜닝 스크립트
├── 3RC 전압 추정 결과.mat         # 시뮬레이션 결과 데이터
├── 기술보고서_2조.docx           # 기술보고서 (Word)
└── 기술보고서_2조.pdf            # 기술보고서 (PDF)
```

## 기술적 배경

### 3RC 등가회로 모델 (3RC ECM)

배터리의 전기화학적 동작을 모델링하기 위해 3개의 RC 병렬회로를 사용합니다:

- **R0**: 내부 저항 (Ohmic Resistance)
- **R1-C1**: 첫 번째 RC 회로 (전하 이동 저항 및 이중층 커패시턴스)
- **R2-C2**: 두 번째 RC 회로 (확산 효과)
- **R3-C3**: 세 번째 RC 회로 (저주파 동적 특성)

### 확장 칼만 필터 (EKF)

비선형 시스템에서의 상태 추정을 위해 EKF를 적용하여 SOC를 실시간으로 추정합니다.

## 사용 방법

### 요구사항

- MATLAB R2020a 이상
- Simulink
- 배터리 OCV 테스트 데이터 (`.xlsx` 또는 `.mat` 형식)

### 실행 순서

1. **파라미터 추출**
   ```matlab
   % OCV 테스트 데이터에서 RC 파라미터 추출
   run('RC3_Parameter_Extract.m')
   ```

2. **파라미터 튜닝**
   ```matlab
   % 추출된 파라미터 튜닝
   run('RC3_Parameter_Tuning.m')
   ```

3. **ECM 시뮬레이션**
   ```matlab
   % 3RC ECM Simulink 모델 실행
   open('RC3_ECM.slx')
   ```

4. **EKF 기반 SOC 추정**
   ```matlab
   % EKF Simulink 모델 실행
   open('RC3_EKF.slx')
   ```

## 데이터 형식

### 입력 데이터

- **전류 데이터**: 배터리에 흐르는 전류 (A)
- **전압 데이터**: 배터리 단자 전압 (V)
- **샘플링 시간**: 1초

### 출력 데이터

- **SOC 추정값**: 0~1 (0%~100%)
- **전압 추정값**: 모델 기반 전압 예측

## 파라미터 설명

| 파라미터 | 설명 | 단위 |
|---------|------|------|
| OCV | 개방회로 전압 | V |
| R0 | 내부 저항 | Ω |
| R1, R2, R3 | RC 회로 저항 | Ω |
| C1, C2, C3 | RC 회로 커패시턴스 | F |
| τ1, τ2, τ3 | 시정수 (τ = R×C) | s |

## 참고 문헌

자세한 기술적 내용은 `기술보고서_2조.pdf`를 참조하세요.

## 팀 정보

- **프로젝트**: 모빌리티 프로젝트 4
- **팀**: 2조

## 라이선스

본 프로젝트는 교육 및 연구 목적으로 개발되었습니다.
