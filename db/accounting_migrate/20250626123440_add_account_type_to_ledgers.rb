class AddAccountTypeToLedgers < ActiveRecord::Migration[8.0]
  ENUM_TYPE_NAME = 'accounting_account_type'
  TRIGGER_FUNCTION_NAME = 'prevent_ledger_account_type_change'
  TRIGGER_NAME = 'prevent_ledger_account_type_change_trigger'

  def up
    create_enum_type
    add_column :ledgers, :account_type, ENUM_TYPE_NAME, null: false
    add_index :ledgers, :account_type
    drop_trigger_function_if_exists
    create_trigger_function
    create_trigger
  end

  def down
    drop_trigger
    drop_trigger_function
    remove_index :ledgers, :account_type
    remove_column :ledgers, :account_type
    # ENUM type left intact for reuse
  end

  private

  def create_enum_type
    execute <<~SQL
      DO $$
      BEGIN
        IF NOT EXISTS (
          SELECT 1 FROM pg_type WHERE typname = '#{ENUM_TYPE_NAME}'
        ) THEN
          CREATE TYPE #{ENUM_TYPE_NAME} AS ENUM (
            'asset', 'equity', 'liability', 'revenue', 'expense'
          );
        END IF;
      END
      $$;
    SQL
  end

  def drop_trigger_function_if_exists
    execute <<~SQL
      DROP FUNCTION IF EXISTS #{TRIGGER_FUNCTION_NAME}();
    SQL
  end

  def create_trigger_function
    execute <<~SQL
      CREATE FUNCTION #{TRIGGER_FUNCTION_NAME}() RETURNS trigger AS $$
      BEGIN
        IF NEW.account_type IS DISTINCT FROM OLD.account_type THEN
          RAISE EXCEPTION 'Cannot change account_type once set';
        END IF;
        RETURN NEW;
      END;
      $$ LANGUAGE plpgsql;
    SQL
  end

  def create_trigger
    execute <<~SQL
      CREATE TRIGGER #{TRIGGER_NAME}
      BEFORE UPDATE ON ledgers
      FOR EACH ROW
      EXECUTE FUNCTION #{TRIGGER_FUNCTION_NAME}();
    SQL
  end

  def drop_trigger
    execute <<~SQL
      DROP TRIGGER IF EXISTS #{TRIGGER_NAME} ON ledgers;
    SQL
  end

  def drop_trigger_function
    execute <<~SQL
      DROP FUNCTION IF EXISTS #{TRIGGER_FUNCTION_NAME}();
    SQL
  end
end
