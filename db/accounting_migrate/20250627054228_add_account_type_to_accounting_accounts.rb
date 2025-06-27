class AddAccountTypeToAccountingAccounts < ActiveRecord::Migration[8.0]
  TRIGGER_FUNCTION_NAME = 'prevent_account_account_type_change'
  TRIGGER_NAME = 'prevent_account_account_type_change_trigger'

  def up
    add_column :accounting_accounts, :account_type, ENUM_TYPE_NAME, null: false
    add_index :accounting_accounts, :account_type

    create_trigger_function
    create_trigger
  end

  def down
    drop_trigger
    drop_trigger_function
    remove_index :accounting_accounts, :account_type
    remove_column :accounting_accounts, :account_type
    # ENUM type left intact for reuse
  end

  private

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
      BEFORE UPDATE ON accounting_accounts
      FOR EACH ROW
      EXECUTE FUNCTION #{TRIGGER_FUNCTION_NAME}();
    SQL
  end

  def drop_trigger
    execute <<~SQL
      DROP TRIGGER IF EXISTS #{TRIGGER_NAME} ON accounting_accounts;
    SQL
  end

  def drop_trigger_function
    execute <<~SQL
      DROP FUNCTION IF EXISTS #{TRIGGER_FUNCTION_NAME}();
    SQL
  end
end
