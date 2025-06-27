class AddLineItemTypeToAccountingEntryLineItems < ActiveRecord::Migration[8.0]
  ENUM_TYPE_NAME = 'accounting_entry_line_item_type'
  TRIGGER_FUNCTION_NAME = 'prevent_entry_line_item_type_change'
  TRIGGER_NAME = 'prevent_entry_line_item_type_change_trigger'

  def up
    create_enum_type
    add_column :accounting_entry_line_items, :line_item_type, ENUM_TYPE_NAME, null: false
    add_index :accounting_entry_line_items, :line_item_type

    create_trigger_function
    create_trigger
  end

  def down
    drop_trigger
    drop_trigger_function
    remove_index :accounting_entry_line_items, :line_item_type
    remove_column :accounting_entry_line_items, :accounting_entry_line_items
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
            'debit', 'credit'
          );
        END IF;
      END
      $$;
    SQL
  end


  def create_trigger_function
    execute <<~SQL
      CREATE FUNCTION #{TRIGGER_FUNCTION_NAME}() RETURNS trigger AS $$
      BEGIN
        IF NEW.line_item_type IS DISTINCT FROM OLD.line_item_type THEN
          RAISE EXCEPTION 'Cannot change line_item_type once set';
        END IF;
        RETURN NEW;
      END;
      $$ LANGUAGE plpgsql;
    SQL
  end

  def create_trigger
    execute <<~SQL
      CREATE TRIGGER #{TRIGGER_NAME}
      BEFORE UPDATE ON accounting_entry_line_items
      FOR EACH ROW
      EXECUTE FUNCTION #{TRIGGER_FUNCTION_NAME}();
    SQL
  end

  def drop_trigger
    execute <<~SQL
      DROP TRIGGER IF EXISTS #{TRIGGER_NAME} ON accounting_entry_line_items;
    SQL
  end

  def drop_trigger_function
    execute <<~SQL
      DROP FUNCTION IF EXISTS #{TRIGGER_FUNCTION_NAME}();
    SQL
  end
end
