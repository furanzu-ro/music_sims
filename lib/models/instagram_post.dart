class InstagramPost {
  final String imageUrl;
  final String caption;

  InstagramPost({
    required this.imageUrl,
    required this.caption,
  });

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'caption': caption,
    };
  }

  factory InstagramPost.fromJson(Map<String, dynamic> json) {
    return InstagramPost(
      imageUrl: json['imageUrl'],
      caption: json['caption'],
    );
  }
}
