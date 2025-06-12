# AWS Application Load Balancer (ALB) Ingress Controller Module

This module sets up the AWS Load Balancer Controller in your EKS cluster, which enables you to use Kubernetes Ingress resources to create and manage AWS Application Load Balancers (ALBs).

## Prerequisites

1. An existing EKS cluster with:
   - OIDC provider configured
   - Worker nodes in private subnets
   - Proper IAM roles and security groups

2. Required tools:
   - AWS CLI (configured with appropriate credentials)
   - kubectl
   - helm (version 3.x)

## Usage

### 1. Basic Module Integration

Add the module to your root `main.tf`:

```hcl
module "alb_ingress" {
  source = "./modules/alb_ingress"

  cluster_name            = module.eks.cluster_name
  cluster_oidc_issuer_url = module.eks.cluster_oidc_issuer_url
  oidc_provider_arn       = module.eks.oidc_provider_arn
  alb_controller_version  = "1.5.3"  # Optional: defaults to this version
}
```

### 2. Required Variables

| Variable Name | Description | Required? | Default |
|--------------|-------------|-----------|----------|
| cluster_name | Name of your EKS cluster | Yes | - |
| cluster_oidc_issuer_url | OIDC issuer URL from your EKS cluster | Yes | - |
| oidc_provider_arn | ARN of the OIDC Provider | Yes | - |
| alb_controller_version | Version of ALB controller to deploy | No | "1.5.3" |

### 3. Using the ALB Ingress Controller

After deploying the module, you can create an Ingress resource. Here's a basic example:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-ingress
  annotations:
    kubernetes.io/ingress.class: alb
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
spec:
  rules:
    - http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: my-service
                port:
                  number: 80
```

### 4. Common Ingress Annotations

| Annotation | Description | Example Value |
|------------|-------------|---------------|
| alb.ingress.kubernetes.io/scheme | Whether the ALB is internet-facing or internal | internet-facing, internal |
| alb.ingress.kubernetes.io/target-type | How to route traffic to pods | ip, instance |
| alb.ingress.kubernetes.io/listen-ports | Ports that ALB should listen on | '[{"HTTP": 80}, {"HTTPS":443}]' |
| alb.ingress.kubernetes.io/certificate-arn | SSL certificate ARN for HTTPS | arn:aws:acm:region:account:certificate/cert-id |
| alb.ingress.kubernetes.io/security-groups | Security groups to attach to ALB | sg-xxxx,sg-yyyy |

### 5. Verification Steps

After deploying the module and creating an Ingress resource:

1. Check if the controller is running:
```powershell
kubectl get pods -n kube-system | Select-String "aws-load-balancer-controller"
```

2. Verify the Ingress resource:
```powershell
kubectl get ingress
```

3. Check ALB controller logs:
```powershell
kubectl logs -n kube-system -l app.kubernetes.io/name=aws-load-balancer-controller
```

### 6. Troubleshooting

Common issues and solutions:

1. **ALB not being created:**
   - Verify IAM roles and policies are correctly configured
   - Check controller logs for permissions issues
   - Ensure VPC has proper tags for ALB discovery

2. **Target pods not being registered:**
   - Verify node security groups allow traffic from ALB
   - Check if service selectors match pod labels
   - Ensure pods are running in supported subnets

3. **SSL/TLS issues:**
   - Verify ACM certificate ARN is correct
   - Ensure certificate is in the same region as ALB
   - Check if certificate is valid and not expired

### 7. Security Considerations

1. Use internal ALBs when possible (`alb.ingress.kubernetes.io/scheme: internal`)
2. Configure security groups to restrict access
3. Enable AWS WAF integration for additional security
4. Use HTTPS with valid certificates for secure communication

### 8. Cost Optimization

Keep in mind that ALBs incur AWS charges. To optimize costs:

1. Use internal ALBs when external access isn't required
2. Delete unused Ingress resources to remove associated ALBs
3. Consider using shared ALBs for multiple services when possible

### 9. Upgrading the Controller

To upgrade the ALB controller version:

1. Update the `alb_controller_version` variable
2. Reapply the Terraform configuration:
```powershell
terraform apply
```

### 10. Monitoring and Logging

Enable monitoring by:

1. Adding CloudWatch metrics annotations:
```yaml
alb.ingress.kubernetes.io/load-balancer-attributes: access_logs.s3.enabled=true,access_logs.s3.bucket=my-bucket
```

2. Configure AWS X-Ray tracing:
```yaml
alb.ingress.kubernetes.io/load-balancer-attributes: routing.http.x_amzn_trace_id=enabled
```

## Support and Resources

- [AWS Load Balancer Controller Documentation](https://kubernetes-sigs.github.io/aws-load-balancer-controller/)
- [ALB Ingress Controller GitHub Repository](https://github.com/kubernetes-sigs/aws-load-balancer-controller)
- [AWS EKS Documentation](https://docs.aws.amazon.com/eks/)