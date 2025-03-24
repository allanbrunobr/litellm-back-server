-- Atualiza registros existentes com IDs
UPDATE "LiteLLM_VerificationToken"
SET id = gen_random_uuid()::text
WHERE id IS NULL;

-- Verifica se todos os registros têm IDs
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM "LiteLLM_VerificationToken" WHERE id IS NULL
    ) THEN
        RAISE EXCEPTION 'Ainda existem registros sem ID';
    END IF;
END $$; 