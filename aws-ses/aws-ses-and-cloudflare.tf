resource "aws_ses_domain_identity" "identity_domain" {
  domain = var.aws_ses_identity_domain_name
}

resource "aws_ses_domain_dkim" "domain_dkim" {
  domain = aws_ses_domain_identity.identity_domain.domain
}

resource "cloudflare_record" "cloudflare_record_domain" {
  allow_overwrite = true
  proxied         = false
  count           = 3 # this line may fail if the amount of dkim output is more than 3, always check.
  zone_id         = var.cloudflare_zone_id
  name            = "${aws_ses_domain_dkim.domain_dkim.dkim_tokens[count.index]}._domainkey.${var.aws_ses_identity_domain_name}"
  value           = "${aws_ses_domain_dkim.domain_dkim.dkim_tokens[count.index]}.dkim.amazonses.com"
  type            = "CNAME"
  ttl             = 60 # this is in multiples of 60. 3600 => 1 hour
}

resource "aws_ses_domain_identity_verification" "aws_ses_domain_verification" {
  domain     = aws_ses_domain_identity.identity_domain.id
  depends_on = [cloudflare_record.cloudflare_record_domain]
}

output "aws_ses_domain_identity_veirifcation_token_2" {
  value = [
    aws_ses_domain_identity.identity_domain.verification_token,
    aws_ses_domain_identity.identity_domain.arn,
    aws_ses_domain_identity.identity_domain.domain,
    aws_ses_domain_identity.identity_domain.id,
  ]
}
output "aws_ses_domain_dkim_output_value" {
  value = aws_ses_domain_dkim.domain_dkim.dkim_tokens
}
