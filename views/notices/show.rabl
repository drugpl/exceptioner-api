object @notice
attributes :id, :message, :created_at, :updated_at

glue :error do
  attributes id: :error_id
end
