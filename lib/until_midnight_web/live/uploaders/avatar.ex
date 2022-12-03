defmodule UntilMidnight.Uploaders.Avatar do
  alias UntilMidnightWeb.Router.Helpers, as: Routes

  @upload_directory_name "uploads"
  @upload_directory_path "priv/static/uploads"

  defp ext(entry) do
    [ext | _] = MIME.extensions(entry.client_type)

    ext
  end

  def get_avatar(socket, entry) do
    Routes.static_path(socket, "/#{@upload_directory_name}/#{entry.uuid}.#{ext(entry)}")
  end

  def update(socket, old_url, entry) do
    if !File.exists?(@upload_directory_path), do: File.mkdir!(@upload_directory_path)

    Phoenix.LiveView.consume_uploaded_entry(socket, entry, fn %{} = meta ->
      dest = Path.join(@upload_directory_path, "#{entry.uuid}.#{ext(entry)}")
      dest_thumb = Path.join(@upload_directory_path, "thumb_#{entry.uuid}.#{ext(entry)}")

      mogrify_thumbnail(meta.path, dest, 300)
      mogrify_thumbnail(meta.path, dest_thumb, 150)

      delete_file(old_url)
      old_url |> get_thumb() |> delete_file()
    end)

    :ok
  end

  def get_thumb(avatar) when avatar == "images/user-without-avatar.svg" do
    avatar
  end

  def get_thumb(avatar) do
    file_name = String.replace_leading(avatar, "/uploads/", "")
    ["/#{@upload_directory_name}", "thumb_#{file_name}"] |> Path.join()
  end

  def delete_file(old_avatar) do
    url = String.replace_leading(old_avatar, "/uploads/", "")
    path = [@upload_directory_path, url] |> Path.join()

    if File.exists?(path), do: File.rm!(path)
  end

  defp mogrify_thumbnail(src_path, dst_path, size) do
    try do
      Mogrify.open(src_path)
      |> Mogrify.resize_to_limit("#{size}x#{size}")
      |> Mogrify.save(path: dst_path)
    rescue
      File.Error -> {:error, :invalid_src_path}
      error -> {:error, error}
    else
      _image -> {:ok, dst_path}
    end
  end
end
