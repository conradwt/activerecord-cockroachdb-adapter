exclude :test_foreign_keys_can_be_created_while_changing_the_table,  "Results of an operation cannot be accessed prior to completion of that operation's transaction. See https://www.cockroachlabs.com/docs/v19.2/architecture/transaction-layer.html#transaction-conflicts"
exclude :test_foreign_keys_accept_options_when_changing_the_table,  "Results of an operation cannot be accessed prior to completion of that operation's transaction. See https://www.cockroachlabs.com/docs/v19.2/architecture/transaction-layer.html#transaction-conflicts"
exclude :test_foreign_key_column_can_be_removed, "Results of an operation cannot be accessed prior to completion of that operation's transaction. See https://www.cockroachlabs.com/docs/v19.2/architecture/transaction-layer.html#transaction-conflicts"
exclude :test_removing_column_removes_foreign_key, "Results of an operation cannot be accessed prior to completion of that operation's transaction. See https://www.cockroachlabs.com/docs/v19.2/architecture/transaction-layer.html#transaction-conflicts"
exclude :test_foreign_key_methods_respect_pluralize_table_names,  "Results of an operation cannot be accessed prior to completion of that operation's transaction. See https://www.cockroachlabs.com/docs/v19.2/architecture/transaction-layer.html#transaction-conflicts"
exclude :test_multiple_foreign_keys_can_be_removed_to_the_selected_one, "Results of an operation cannot be accessed prior to completion of that operation's transaction. See https://www.cockroachlabs.com/docs/v19.2/architecture/transaction-layer.html#transaction-conflicts"
exclude :test_multiple_foreign_keys_can_be_added_to_the_same_table, "Results of an operation cannot be accessed prior to completion of that operation's transaction. See https://www.cockroachlabs.com/docs/v19.2/architecture/transaction-layer.html#transaction-conflicts"
