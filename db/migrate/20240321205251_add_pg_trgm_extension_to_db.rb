class AddPgTrgmExtensionToDb < ActiveRecord::Migration[7.1]
  def change
    execute "create extension pg_trgm;"
  end
end
