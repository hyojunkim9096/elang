-- V21: 문제 변형 테이블에 언어 설정 컬럼 추가

ALTER TABLE question_transform
ADD COLUMN question_lang VARCHAR(2) NOT NULL DEFAULT 'KO' COMMENT '문제 언어 (KO, EN)' AFTER difficulty,
ADD COLUMN choice_lang VARCHAR(2) NOT NULL DEFAULT 'KO' COMMENT '선택지 언어 (KO, EN)' AFTER question_lang;
