class AddPreventInstitutionChangeTriggerToLedgers < ActiveRecord::Migration[8.0]
  def up
    execute <<-SQL
      CREATE FUNCTION prevent_financial_institution_id_change_to_ledgers() RETURNS trigger AS $$
      BEGIN
        -- Only raise an error if the old value is not null and has changed
        IF OLD.financial_institution_id IS NOT NULL AND NEW.financial_institution_id IS DISTINCT FROM OLD.financial_institution_id THEN
          RAISE EXCEPTION 'Cannot change financial_institution_id once set';
        END IF;
        RETURN NEW;
      END;
      $$ LANGUAGE plpgsql;

      CREATE TRIGGER prevent_financial_institution_id_change_trigger
      BEFORE UPDATE ON ledgers
      FOR EACH ROW
      EXECUTE FUNCTION prevent_financial_institution_id_change_to_ledgers();
    SQL
  end

  def down
    execute <<-SQL
      DROP TRIGGER IF EXISTS prevent_financial_institution_id_change_trigger ON ledgers;
      DROP FUNCTION IF EXISTS prevent_financial_institution_id_change_to_ledgers();
    SQL
  end
end
