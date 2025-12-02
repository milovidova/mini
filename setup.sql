-- setup.sql - SQL для создания таблиц в Supabase

-- 1. Таблица пользователей
CREATE TABLE IF NOT EXISTS users (
    id BIGSERIAL PRIMARY KEY,
    telegram_id TEXT UNIQUE,
    username TEXT NOT NULL,
    email TEXT,
    password_digest TEXT,
    experience_level TEXT DEFAULT 'beginner',
    balance INTEGER DEFAULT 3,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Таблица проектов
CREATE TABLE IF NOT EXISTS projects (
    id BIGSERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    category TEXT,
    feedback_request TEXT,
    user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    image_url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Таблица фидбеков
CREATE TABLE IF NOT EXISTS feedbacks (
    id BIGSERIAL PRIMARY KEY,
    content TEXT NOT NULL,
    project_id BIGINT REFERENCES projects(id) ON DELETE CASCADE,
    user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    category TEXT DEFAULT 'general',
    is_helpful BOOLEAN,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. Включаем RLS (Row Level Security)
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE feedbacks ENABLE ROW LEVEL SECURITY;

-- 5. Создаем политики доступа
CREATE POLICY "Разрешить все для users" ON users
    FOR ALL USING (true);

CREATE POLICY "Разрешить чтение проектов всем" ON projects
    FOR SELECT USING (true);

CREATE POLICY "Разрешить создание проектов всем" ON projects
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Разрешить чтение фидбеков всем" ON feedbacks
    FOR SELECT USING (true);

CREATE POLICY "Разрешить создание фидбеков всем" ON feedbacks
    FOR INSERT WITH CHECK (true);

-- 6. Создаем индексы для ускорения
CREATE INDEX IF NOT EXISTS idx_projects_user_id ON projects(user_id);
CREATE INDEX IF NOT EXISTS idx_feedbacks_project_id ON feedbacks(project_id);
CREATE INDEX IF NOT EXISTS idx_users_telegram_id ON users(telegram_id);