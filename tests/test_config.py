import os
import unittest
from unittest.mock import patch, MagicMock
from services.data_loader import dal


class ConfigTests(unittest.TestCase):
    def test_missing_or_blank_password_never_connects(self):
        for value in ("", " "):
            with patch.dict(os.environ, {"DB_PASSWORD": value}, clear=True), patch.object(dal.pymysql, "connect") as connect:
                with self.assertRaisesRegex(ValueError, "DB_PASSWORD must be set"):
                    dal.get_conn()
                connect.assert_not_called()

    def test_synthetic_query_with_injected_client(self):
        rows = [{"id": 1, "first_name": "Demo", "last_name": "Person"}]
        conn = MagicMock()
        conn.__enter__.return_value.cursor.return_value.__enter__.return_value.fetchall.return_value = rows
        value = "synthetic" + "-test-value"
        with patch.dict(os.environ, {"DB_PASSWORD": value}, clear=True), patch.object(dal.pymysql, "connect", return_value=conn) as connect:
            self.assertEqual(dal.print_data(), rows)
            self.assertEqual(connect.call_args.kwargs["password"], value)
