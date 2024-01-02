json.content format_content(@question.content)
json.(@question, :created_at, :updated_at)
